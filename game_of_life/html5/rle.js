function RLE()
{
  this.encoding = "";
  
  this.decode = function(encoding)
  {
    var lines = encoding.split('\n');
    var states = [];
    
    for (var i in lines)
    {
      var line = lines[i];
      line = line.trim();
      line = line.replace(/ /gi, '');
      
      // Ignore comments
      if (line.charAt(0) == '#') continue;
      
      // Parse size and rules
      else if (line.charAt(0) == 'x')
      {
        line = line.replace('x=', '');
        line = line.replace('y=', '');
        size = line.split(',', 2);
      }
      
      // Parse RLE
      else
      {
        this.parse_line(line, states);
      }
      
    }
    
    return states;
  }
  
  this.parse_line = function(line, states)
  {
    var i = 0;
    var char;
    var run_count = "";
    while (char = line.charAt(i))
    {
      // Last char or End of line
      if ((char == '!') || (char == '$'))
      {
        states.push(char);
        i++;
        continue;
      }
      else
      {
        if ((char == 'b') || (char == 'o'))
        {
          var count = parseInt(run_count);
          if (isNaN(count)) states.push(char);
          else
          {
            while (count > 0) { states.push(char); count--; }
            run_count = "";
          }
        }
        else
        {
          run_count += char;
        }
      }
      i++;
    }
  
  }
  
}
