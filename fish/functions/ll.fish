function ll --wraps=ls --description 'List contents of directory using long format'
    ls -lah --group-directories-first $argv
end
