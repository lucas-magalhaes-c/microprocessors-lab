ENTRY(_start)
SECTIONS
{
    . = 0x0;
    .text : { * (.text); }
    . = ALIGN(8);
    stack_top = 0x2000;
    undefined_stack_top = 0x3000;
    interrupt_stack_top = 0x4000;
    user_stack_top = 0x5000;
    linhaA = 0x5050;
    linhaB = 0x5100;
    nproc = 0x5150;
}
