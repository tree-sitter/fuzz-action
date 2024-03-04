/runtime error:/ {
  print gensub(prefix "([^:]+):([0-9]+):([0-9]+): runtime error: (.+)",
               "::notice file=\\2,line=\\3,col=\\4,title=Sanitizer::\\5", 1)
}

/SUMMARY: AddressSanitizer: [^0-9]/ {
  print gensub("SUMMARY: AddressSanitizer: ([A-Za-z-]+) " prefix "([^:]+):([0-9]+):([0-9]+) (.+)",
               "::error file=\\3,line=\\4,col=\\5,title=Sanitizer::\\1 \\6", 1)
}

/ERROR: LeakSanitizer:/ {
  getline; getline; getline
  if ($0 ~ /in __interceptor/) getline
  print gensub("    #1 0x[a-f0-9]+ (in [A-Za-z0-9_]+) " prefix "([^:]+):([0-9]+):([0-9]+)",
               "::error file=\\3,line=\\4,col=\\5,title=Sanitizer::detected memory leak \\1", 1)
}

/ERROR: libFuzzer: out-of-memory/ {
  getline; getline; getline
  while ($0 ~ /in (__|fuzzer)/) getline
  if ($0 ~ /^Live Heap Allocations/)
    print "::error file=src/scanner.c,title=Sanitizer::out of memory (potential infinite loop)"
  else
    print gensub("    #[0-9]+ 0x[a-f0-9]+ (in [A-Za-z0-9_]+) " prefix "([^:]+):([0-9]+):([0-9]+)",
                 "::error file=\\3,line=\\4,col=\\5,title=Sanitizer::out of memory \\1", 1)
}
