struc db [data] {
	common
	. db data
	.len = $ - .
}

macro print string, len {
        match , len \{
		write STDOUT, string, string#.len
        \}
        match any, len \{
		write STDOUT, string, len
        \}
}

macro input buffer, len {
        match , len \{
		read STDIN, buffer, buffer#.len
        \}
        match any, len \{
		read STDin, buffer, len
        \}
}

