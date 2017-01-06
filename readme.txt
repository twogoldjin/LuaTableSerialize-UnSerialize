Desc: Lua table serialize & unserialize
Author: twogold

e.g.
local testTB = {"hello", ["key"] = {3, 4},  55};
Serialize Result :  {s5hellob55;s3key{5152}}
Unserialize Result :  {"hello", ["key"] = {3, 4},  55}