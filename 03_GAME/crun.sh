# Create the "compiled" folder if is does not exist
if [ ! -d "03_GAME/compiled" ]; then
    mkdir -p "03_GAME/compiled"
fi

cobc -x 03_GAME/01_main.cob 03_GAME/gameutils.c -o 03_GAME/compiled/01_main

compile_status=$?

# Check if compilation was successful
if [ $compile_status -eq 0 ]; then
    ./03_GAME/compiled/01_main
else
    echo "Compilation failed. Game not executed."
fi