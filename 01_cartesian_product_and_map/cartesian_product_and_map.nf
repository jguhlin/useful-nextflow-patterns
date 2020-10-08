// Runnable, and works...

a = Channel.from(1,2,3,4,5)
b = Channel.from(6..10)
cartesian_channel = a.combine(b).map { x -> [x[0], x[1], "filename_${x[0]}_${x[1]}.txt" ] }
process prove_it {
        echo true // Let's us see it
        input:
                set x, y, filename from cartesian_channel
"""
echo ${x} and ${y} make ${filename}
"""
}