#!/usr/bin/env nextflow

// Copyright (C) 2017 IARC/WHO

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


params.help	= null
params.config = null
params.cpu = 1
params.mem = 4
params.input_folder = null

log.info ""
log.info "----------------------------------------------------------------"
log.info "           Quality control with Qualimap  and MultiQC           "
log.info "----------------------------------------------------------------"
log.info "Copyright (C) IARC/WHO"
log.info "This program comes with ABSOLUTELY NO WARRANTY; for details see LICENSE"
log.info "This is free software, and you are welcome to redistribute it"
log.info "under certain conditions; see LICENSE for details."
log.info "--------------------------------------------------------"
if (params.help) {
    log.info "--------------------------------------------------------"
    log.info "                     USAGE                              "
    log.info "--------------------------------------------------------"
    log.info ""
    log.info "-------------------QC-------------------------------"
    log.info ""
    log.info "nextflow run iarcbioinfo/Qualimap.nf   --qualimap /path/to/qualimap  --multiqc /path/to/multiqc --samtools /path/to/samtools --input_folder /path/to/bam  --output_folder /path/to/output"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--input_folder         FOLDER               Folder containing bam files"
    log.info ""
    log.info "Optional arguments:"
    log.info "--qualimap             PATH                 Qualimap installation dir (default=qualimap)"
    log.info "--samtools             PATH                 Samtools installation dir (default=samtools)"
    log.info "--multiqc              PATH                 MultiQC installation dir (default=multiqc)"
    log.info "--feature_file         FILE                 Qualimap feature file for coverage analysis"
    log.info "--output_folder        PATH                 Output directory for html and zip files (default=.)"
    log.info "--cpu                  INTEGER              Number of cpu to use (default=1)"
    log.info "--config               FILE                 Use custom configuration file"
    log.info "--mem                  INTEGER              Size of memory used. Default 4Gb"
    log.info ""
    log.info "Flags:"
    log.info "--help                                      Display this message"
    log.info ""
    exit 0
}

assert (params.input_folder != null) : "please provide the --input_folder option"

params.feature_file = 'NO_FILE'
qualimap_ff         = file(params.feature_file)

bams = Channel.fromPath( params.input_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.input_folder}" }

process qualimap {
    cpus params.cpu
    memory params.mem+'G'
    tag { bam_tag }
    container 'maxulysse/sarek:latest'

    publishDir "${params.output_folder}/individual_reports", mode: 'copy'

    input:
    file bam from bams
    file qff from qualimap_ff

    output:
    file ("${bam_tag}") into qualimap_results
    file ("${bam_tag}.stats.txt") into flagstat_results

    shell:
    bam_tag=bam.baseName
    feature = qff.name != 'NO_FILE' ? "--feature-file $qff" : ''
    '''
    !{params.qualimap} bamqc -nt !{params.cpu} !{feature} --skip-duplicated -bam !{bam} --java-mem-size=!{params.mem}G -outdir !{bam_tag} -outformat html
    !{params.samtools} flagstat !{bam} > !{bam_tag}.stats.txt
    '''
}

process multiqc {
    cpus params.cpu
    memory params.mem+'G'
    container 'ewels/multiqc:v1.7'


    publishDir "${params.output_folder}", mode: 'copy'

    input:
    file qualimap_results from qualimap_results.collect()
    file flagstat_results from flagstat_results.collect()

    output:
    file("multiqc_report.html") into final_output
    file("multiqc_data/") into final_output_data

    shell:
    '''
    !{params.multiqc} .
    '''
}
