database -open waves -into waves_sim.shm -default
probe -create -database waves present_tb.clk
probe -create -database waves present_tb.nrst
probe -create -database waves present_tb.start
probe -create -database waves present_tb.eoc
probe -create -database waves present_tb.plaintext
probe -create -database waves present_tb.key
probe -create -database waves present_tb.ciphertext

#
