
set folders [glob -directory "./" -type d  *]

puts " ================= Synthesis setup scripts ================= "
foreach folder $folders {

    # check if first and second letters are HIGHER case
    if {[regexp {^[./A-Z_]+$} $folder]} {
        set path [pwd]
        puts "folder $path"

        cd $folder
        set normal_pipe [glob -directory "./" -type d  *]

        foreach dir $normal_pipe {
            cd $dir
            set FOLDERS [glob -directory "./" NN*]

            foreach folder $FOLDERS {
                # run script inside folder
                cd $folder/cadence_synthesis

                source clean.tcl
                # source clean_synthesis.tcl
                #source setup_synthesis.tcl
                cd ../../
            }
            cd ../
        }
        cd ../
    }
}
