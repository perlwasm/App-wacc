(module
  (import "foo" "bar" (func $bar (type 0)))
  (func (export "a") (param i32 f32) (result f64)
    f64.const 0)
  (global (export "") (mut i32) (i32.const 1))
  (memory (export "mem") 1)
  (table (export "table") 1 funcref)
)
