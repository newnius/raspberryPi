NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   008C   000D =     13. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       008C  __idata_start
       0099  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   009A   0494 =   1172. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       004D  __text_start
       004D  __start
       006F  _exit
       0070  _ds1302_write
       00BC  _ds1302_read
       0108  _check_ds1302
       0113  _ds1302_write_time
       013B  _ds1302_read_time
       015F  _delay_us
       0164  _delay
       0172  _timer0_init
       017B  _timer0_ovf_isr
       01D7  _Process
       0234  _main
       027B  push_xgsetF00C
       0282  pop_xgsetF00C
       0289  push_xgset303C
       0290  pop_xgset303C
       0297  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0100   000D =     13. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0100  _Table
       0100  __data_start
       010B  _sel
       010C  _temp_pa
       010D  __data_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   010D   000E =     14. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       010D  __bss_start
       010D  _s
       0113  _timer
       011B  __bss_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0044 =     68. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

C:\iccv7avr\lib\crtatmega.o	[ crtatmega.s ]
DS1302.o	[ DS1302.C ]
<library>	[ gpushz.s, gpusha.s ]

User Global Definitions

ram_end = 0x10ff
hwstk_size = 0x1e

User Base Address Definitions

func_lit = 0x8c
data = 0x100
eeprom:0.4096

