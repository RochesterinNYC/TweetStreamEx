    file = File.new("mathterms.txt")
    @arr = Array.new
    while (line = file.gets)
      
      @arr.push line
    end 
    puts @arr
    file.close
