(fn map [cmd tbl]
  "maps through a sequential table and applies cmd to each element, returning a new table"
  (accumulate
    [ o [] _ v (ipairs tbl) ]
    (do (table.insert o (cmd v)) o)))

(fn merge [...]
  (accumulate
    [ output [] _ tbl (ipairs [...]) ]
    (do
      (accumulate
        [ o output _ v (ipairs tbl) ]
        (do
          (table.insert o v) o))
      output)
    )
  )

{
 :map map
 :merge merge
  }
