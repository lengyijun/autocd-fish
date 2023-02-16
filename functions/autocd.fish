function autocd
    if test $status -eq 0
        switch (commandline --cut-at-cursor)
            case ''
                if string match -q "mkdir*" $history[1]
                    set -l splits (string split -n ' ' $history[1])
                    for i in $splits[-1..2]
                        if not string match -q -- "-*" $i
                            commandline "cd $i"
                            return
                        end
                    end
                end
                if string match -q "git clone*" $history[1]
                    set -l splits (string split -n ' ' $history[1])
                    for i in $splits[-1..3]
                        if string match -q "https://*" $i
                            set -l split1 (string split -n '/' $i)
                            commandline "cd $split1[-1]"
                            return
                        end
                        if string match -q "git@*.git" $i
                            set -l last (string split '/' $i)[-1]
                            set -l dir_name (string sub --end -4 $last)
                            commandline "cd $dir_name"
                            return
                        end
                        if not string match -q -- "-*" $i
                            commandline "cd $i"
                            return
                        end
                    end
                end
            case '*'
                commandline -i " "
        end
    end
end
