#!/bin/bash


SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
iCOV_PROJ_DIR="$SCRIPT_DIR/.."
CONFIG_DIR=$iCOV_PROJ_DIR/config
source $CONFIG_DIR/env.conf

usage() {
  echo "usage: getcov coverage_data src_dir diff_info_file [[-s] [-o output_dir] [-i info_file] [-v]] | [-h]]"
}

# Fix for the new LLVM-COV that requires gcov to have a -v parameter
LCOV() {
    "${LCOV_PATH}/lcov" "$@" --gcov-tool "${scripts}/llvm-cov-wrapper.sh"
    echo "${LCOV_PATH}/lcov" "$@" --gcov-tool "${scripts}/llvm-cov-wrapper.sh"
}





main() {
  scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  LCOV_PATH="${scripts}/lcov-mm/bin"

  OBJ_DIR="$1"
  Data_DIR="$2"
  DIFF_INFO_FILE="$3"


  LCOV_INFO=Coverage.info
  shift 2
  while [ "$1" != "" ]; do
    case $1 in
      -s|--show)
        show_html=1
        echo "Show HTML Report"
        ;;
      -o)
        shift
        output_dir=$1
        echo "output_dir = ${output_dir}"
        ;;
      -i)
        shift
        LCOV_INFO=$1
        echo "LCOV_INFO = ${LCOV_INFO}"
        ;;
      -v)
        verbose=1
        echo "Verbose"
        ;;
      -h|--help)
        usage
        echo "Show Help"
        exit
        ;;
      *)
        usage
        exit 1
    esac
    shift
  done
echo "-------------------step0-------------------------------"
  mkdir -p $output_dir
  cp -rf $Data_DIR $OBJ_DIR
  [ "$output_dir" = "" ] &&   output_dir="${scripts}/report" &&   mkdir -p $output_dir
  LCOV_INFO="$output_dir/$LCOV_INFO"

  if [ "$verbose" = "1" ]; then
    report_values
  fi
echo "-------------------step1-------------------------------"

  #remove_old_report
  enter_lcov_dir
  echo "-------------------step2-------------------------------"

  gather_coverage
  echo "-------------------step3-------------------------------"

  exclude_data
  echo "-------------------step4-------------------------------"


  case "$(uname -s)" in
   Darwin)
     SED="gsed"
     ;;
   *)
    SED="gsed"
     ;;
  esac
  $SED -Ei "s|^SF:$BUILD_SRC_PATH/(.+)$|SF:$SRCROOT/\1|g" "$LCOV_INFO"
  
  echo "$SED -Ei s|^SF:$BUILD_SRC_PATH/(.+)$|SF:$SRCROOT/\1|g $LCOV_INFO"
  
  generate_html_report
  if [ "$show_html" = "1" ]; then
    show_html_report
  fi
}

report_values() {
  echo "iCoverage: Environment"
  echo "scripts    : ${scripts}"
  echo "output_dir : ${output_dir}"
  echo "LCOV_INFO  : ${LCOV_INFO}"
  echo "SRCROOT    : ${SRCROOT}"
  echo "OBJ_DIR   : ${OBJ_DIR}"
  echo "LCOV_PATH  : ${LCOV_PATH}"
}

remove_old_report() {
  if [ "$verbose" = "1" ]; then
    echo "iCoverage: Removing old report"
  fi

  pushd "${output_dir}"
  if [ -e lcov ]; then
    rm -r lcov
  fi
  popd
}

enter_lcov_dir() {
  cd "${output_dir}"
  mkdir lcov
  cd lcov
}

gather_coverage() {
  if [ "$verbose" = "1" ]; then
    echo "iCoverage: Gathering coverage"
  fi

  #LCOV --capture --derive-func-data -b "${SRCROOT}" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  echo "LCOV --capture -b ${SRCROOT} -d ${OBJ_DIR} -o ${LCOV_INFO}"
  LCOV --capture -b "${SRCROOT}" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
}

exclude_data() {
  if [ "$verbose" = "1" ]; then
    echo "iCoverage: Excluding data"
  fi
  LCOV --remove "${LCOV_INFO}" "*/Developer/SDKs/*" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  LCOV --remove "${LCOV_INFO}" "*/Developer/Toolchains/*" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  LCOV --remove "${LCOV_INFO}" "*/main.m" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  LCOV --remove "${LCOV_INFO}" "*/Pods/Headers/*" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  LCOV --remove "${LCOV_INFO}" "*/PlatformSDK/PlatformSDK/Classes/Vendor/*" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
  
  #Remove anything the .xcodecoverageignore file has specified should be ignored.
  if [ -f "${SRCROOT}/.xcodecoverageignore" ]; then
    (cat "${SRCROOT}/.xcodecoverageignore"; echo) | while read IGNORE_THIS; do
      #use eval to expand any of the variables and then pass them to the shell - this allows
      #use of wildcards in the variables. 
      eval LCOV --remove "${LCOV_INFO}" "${IGNORE_THIS}" -d "${OBJ_DIR}" -o "${LCOV_INFO}"
    done
  fi
}



generate_html_report() {
  if [ "$verbose" = "1" ]; then
    echo "iCoverage: Generating HTML report"
  fi
     
  #"${LCOV_PATH}/genhtml" --output-directory . "${LCOV_INFO}"  --no-function-coverage -i "${DIFF_INFO_FILE}"  --diff-coverage
  #"${LCOV_PATH}/genhtml" --output-directory . "${LCOV_INFO}"  --no-function-coverage -i "${DIFF_INFO_FILE}"  --diff-coverage --prefix $SRCROOT
  #"${LCOV_PATH}/genhtml" --output-directory . "${LCOV_INFO}"  --no-function-coverage -i "${DIFF_INFO_FILE}"  --diff-coverage --prefix $SRCROOT
  echo "genhtml ${LCOV_INFO} -o ${output_dir}"
  genhtml ${LCOV_INFO} -o ${output_dir}

}



show_html_report() {
  if [ "$verbose" = "1" ]; then
    echo "iCoverage: Opening HTML report"
  fi

  open index.html
}

main "$@"
