// RUN: rm -rf %t && mkdir -p %t
// RUN: %target-swift-frontend -assume-parsing-unqualified-ownership-sil -import-objc-header %S/Inputs/c_functions.h -primary-file %s -emit-ir | %FileCheck %s

// This is deliberately not a SIL test so that we can test SILGen too.

// CHECK-LABEL: define hidden swiftcc void @_T011c_functions14testOverloadedyyF
func testOverloaded() {
  // CHECK: call void @_Z10overloadedv()
  overloaded()
  // CHECK: call void @_Z10overloadedi(i32{{( signext)?}} 42)
  overloaded(42)
  // CHECK: call void @{{.*}}test_my_log
  test_my_log()
} // CHECK: {{^}$}}

func test_indirect_by_val_alignment() {
  let x = a_thing()
  log_a_thing(x)
}

// CHECK-LABEL: define hidden swiftcc void  @_T011c_functions30test_indirect_by_val_alignmentyyF()
// CHECK: %indirect-temporary = alloca %TSC7a_thingV, align [[ALIGN:[0-9]+]]
// CHECK: [[CAST:%.*]] = bitcast %TSC7a_thingV* %indirect-temporary to %struct.a_thing*
// CHECK: call void @log_a_thing(%struct.a_thing* byval align [[ALIGN]] [[CAST]])
// CHECK: define internal void @log_a_thing(%struct.a_thing* byval align [[ALIGN]]
