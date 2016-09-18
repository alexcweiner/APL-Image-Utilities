⍝⍝⍝ Base Library section for L2 portability
∇out←∆ucs input
out←⎕ucs input
∇

∇out←fclose tn
out←⎕fio[4] tn
∇

∇tn←fopen_r path
tn← ⎕fio[3] path
∇

∇tn←fopen_wr path
tn←"wr" ⎕fio[3] path
∇

∇data←numberbytes fread tn
data←numberbytes ⎕fio[6] tn
∇

∇out← data fwrite tn
out←data ⎕fio[7] tn
∇
⍝⍝⍝ END Base Library section for L2 portability

∇out← om bool
out←bool/⍳⍴bool
∇

(IMG∆BMP∆word_length IMG∆BMP∆dword_length IMG∆BMP∆char_length IMG∆BMP∆byte_length)←2 4 1 1

∇dword← num_bytes IMG∆BMP∆data2bytes data
dword← ⌽(num_bytes/256)⊤ data
∇

∇data← IMG∆BMP∆bytes2data bytes
data←256 ⊥⌽⊃ bytes
∇

∇filedata ← IMG∆BMP∆read_data_from_path im_path;tie;file_size;z
tie	  ←fopen_r im_path
file_size ←IMG∆BMP∆bytes2data 2↓6 fread tie
z	  ←fclose tie
tie	  ←fopen_r im_path
filedata  ←file_size fread tie
z	  ←fclose tie
∇

∇metadata←IMG∆BMP∆full_header_to_metadata full_header;IDbits;filesize;reservedbytes;bmp_offset
IDbits		←∆ucs⊃full_header[1]
filesize	←IMG∆BMP∆bytes2data⊃full_header[2]
reservedbytes	←⊃full_header[3]
bmp_offset	←IMG∆BMP∆bytes2data⊃full_header[4]
metadata	←IDbits filesize reservedbytes bmp_offset
∇

⍝partition-enclose on the head of a vector
∇out← contents IMG∆BMP∆PE_head  pvector
out←pvector⊂contents↑⍨⍴pvector
∇

∇final_bitmap←IMG∆BMP∆40_read_from_path im_path;contents;bit_lengths;header_size;full_header;IDbits;filesize;reservedbytes;bmp_offset;DIB_full_header;remaining_contents;lh;hw;vw;np;bpp;cm;isz;hr;vr;cip;nic;bytes_perpixel
contents←IMG∆BMP∆read_data_from_path im_path
bit_lengths←2 1 4 1 ×IMG∆BMP∆char_length IMG∆BMP∆dword_length IMG∆BMP∆byte_length IMG∆BMP∆dword_length
header_size←+/bit_lengths
full_header←contents IMG∆BMP∆PE_head om bit_lengths
(IDbits filesize reservedbytes bmp_offset)←IMG∆BMP∆full_header_to_metadata full_header
→('BM'≡IDbits)/L∆SUPPORTEDFILE
→0			⍝remaining_contents←header_size↓contents
⍝lh=length_header 	hw=horiz_width 			vw=vert_width	np=num_planes 
⍝bpp=bits_perpixel	cm=compression_method 		isz=image_size	hr=horiz_resolution 
⍝vr=vert_resolution	cip=number_colorsinpallette 	nic=number_importantcolors
L∆SUPPORTEDFILE:	 
L∆DIB40:	
DIB40_format	←3 2 6 /IMG∆BMP∆dword_length IMG∆BMP∆word_length IMG∆BMP∆dword_length	
DIB_full_header	←(header_size↓contents) IMG∆BMP∆PE_head om DIB40_format
(lh hw vw np bpp cm isz hr vr cip nic)←IMG∆BMP∆bytes2data¨DIB_full_header
⍝bytes_perpixel←bpp÷bitsinabyte←8
final_bitmap	←⍉vw hw 3⍴bmp_offset↓contents
∇

∇HD←IMG∆BMP∆init_header bmp
HD←⍳0
⍝Always start with 'BM'
HD      ←HD,,⌽IMG∆BMP∆char_length  IMG∆BMP∆data2bytes ∆ucs 'BM'

⍝then the filesize, blank for right now
HD      ←HD,, IMG∆BMP∆dword_length IMG∆BMP∆data2bytes 0

⍝Four Reserved bytes
HD      ←HD,, IMG∆BMP∆byte_length  IMG∆BMP∆data2bytes 0 0 0 0

⍝bitmap offset. looks like it can default to 54
HD      ←HD,, IMG∆BMP∆dword_length IMG∆BMP∆data2bytes offset←54

⍝length of bitmap info header.  40
HD      ←HD,, IMG∆BMP∆dword_length IMG∆BMP∆data2bytes 40

⍝horizontal then vertical widths
HD      ←HD,,∈IMG∆BMP∆dword_length IMG∆BMP∆data2bytes¨⌽1↓⍴bmp

⍝number of planes. They say its always 1...
HD      ←HD,, IMG∆BMP∆word_length  IMG∆BMP∆data2bytes 1

⍝bits per pixel...24?
HD      ←HD,, IMG∆BMP∆word_length  IMG∆BMP∆data2bytes 24
∇

∇sucess← path IMG∆BMP∆bitmap_image_to_file bmp;check;ERR;HD;tie;offset;img
L∆GOODIMAGE:
HD	←(offset←54)↑∈IMG∆BMP∆init_header bmp
img	←HD,∈⍉bmp
img[⎕io+ 2 3 4 5]←⌽,IMG∆BMP∆dword_length IMG∆BMP∆data2bytes ⍴img
sucess←img fwrite tie← fopen_wr path
z←fclose tie
∇
