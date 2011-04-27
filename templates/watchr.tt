# run tests when they're changed
watch('Tests/.*hs'){|md| system "tbc #{md[0]}"}
# for the moment, when anything changes, run everything
# we could be more sophisticated, but let's get it running first.
# bit of a conflict here - tbc wants test_*, which hlint doesn't like
# finesse it away for now.
watch('src/(.*).hs') {|md| system "tbc Tests; hlint Tests -i 'Use camelCase'; hlint src"} 

