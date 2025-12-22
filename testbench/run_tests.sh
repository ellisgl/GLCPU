#!/usr/bin/env bash
set -euo pipefail

failed=0

run_tb() {
  name="$1"
  tb="$2"
  files="$3"
  echo "\n=== Running ${name} ==="
  if iverilog -g2012 -Wall -o ${name}.vvp "${tb}" ${files} && vvp ${name}.vvp | tee ${name}_run.log; then
    if grep -q "TEST RESULT: PASS" ${name}_run.log; then
      echo "${name}: PASS"
    else
      echo "${name}: FAIL"
      failed=1
    fi
  else
    echo "${name}: FAIL (sim error)"
    failed=1
  fi
}

run_tb alu_select "testbench/alu_select_tb.v" alu_select.v
run_tb alu_slice "testbench/alu_slice_tb.v" "alu_slice.v alu_op.v"
run_tb alu "testbench/alu_tb.v" "alu.v alu_select.v alu_slice.v"

if [ "$failed" -ne 0 ]; then
  echo "\nSOME TESTS FAILED"
  exit 1
else
  echo "\nALL TESTS PASSED"
  exit 0
fi
