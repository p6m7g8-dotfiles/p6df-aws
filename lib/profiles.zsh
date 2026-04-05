# shellcheck shell=bash
######################################################################
#<
#
# Function: stream  = p6df::modules::aws::profiles::list()
#
#  Returns:
#	stream - 
#
#>
######################################################################
p6df::modules::aws::profiles::list() {

  functions | p6_filter_row_select_regex '^p6_awsa' | p6_filter_column_pluck 1

  p6_return_stream
}
