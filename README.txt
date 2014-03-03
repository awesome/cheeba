= Cheeba

* http://rubygems.org/gems/cheeba
* http://github.com/awesome/cheeba
* http://seattlerb.org

== DESCRIPTION:

Simple data serialization like YAML, but in pure Ruby and without dependencies.

== FEATURES/PROBLEMS:

* hash insert order is fucked--tests don't pass
* considered using orderedhash gem to solve hash insert order for ruby 1.8.7

== SYNOPSIS:

$ cheeba
Cheeba 1.1.0
    -r, --read FILENAME              .cash file to Ruby Hash or Array
    -w, --write FILENAME,FILENAME    Hash or Array => .cash file
    -d, --dotfile [HOME]             Create .cheeba dotfile
    -v, --version                    Display verison number
    -h, --help                       Show this message
        --[no-]auto_sym              conv keys & vals: ":both" => :both
        --[no-]auto_sym_keys         conv keys: ":key" => :key
        --[no-]auto_sym_vals         conv vals: ":val" => :val
        --[no-]auto_true             conv keys & vals: "true" => true
        --[no-]auto_true_keys        conv keys: "true" => true
        --[no-]auto_true_vals        conv vals: "true" => true
        --[no-]docs                  doc separator first level hash nodes
        --[no-]dot                   use dotfile if it exists
        --[no-]int                   conv keys & vals: "1" => 1
        --[no-]int_keys              conv keys: "1" => 1
        --[no-]int_vals              conv vals: "1" => 1
        --[no-]list                  return hash of addresses & comments
        --[no-]strip                 strip keys & vals: " both " => "both"
        --[no-]strip_keys            strip keys: " key " => "key"
        --[no-]strip_vals            strip vals: " val " => "val"
        --[no-]symbolize             force conv keys & vals: "both" => :both
        --[no-]symbolize_keys        force conv keys: "key" => :key
        --[no-]symbolize_vals        force conv vals: "val" => :val
        --[no-]sym_str               conv str (no int) k & v: "b" => :b
        --[no-]sym_str_keys          conv string keys(no int): "key" => :key
        --[no-]sym_str_vals          conv string vals(no int): "val" => :val
        --[no-]yaml                  write files with YAML type array syntax


== REQUIREMENTS:

Ruby 1.8.7
* https://bugs.ruby-lang.org/projects/ruby-187/repository
* https://www.ruby-lang.org/en/news/2013/06/30/we-retire-1-8-7/

Gems
* rake 0.8.7 https://rubygems.org/gems/rake
* rubygems 1.2.0 - 1.6.2 https://rubygems.org/gems/rubygems-update
* minitest 1.3.1 - 1.7.2 https://rubygems.org/gems/hoe
* hoe 1.8.2 - https://rubygems.org/gems/hoe 

== INSTALL:

gem install cheeba

== LICENSE:

(The MIT License)

Copyright (c) 2008-2014 SoAwesomeMan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
