(fn map [cmd tbl]
  "maps through a sequential table and applies cmd to each element, returning a new table"
  (icollect [_ v (ipairs tbl)] (cmd v)))

(fn merge [...]
  "merges all tables passed in into a new table"
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
