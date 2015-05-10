I always wanted a 6809 machine. I still have the A4 notebook where I sketched out design ideas. However, I never simultaneously had the time and money to build one from scratch (even though I have accumulated all of the parts in my junk box over the years).

When I saw this http://searle.hostei.com/grant/Multicomp/index.html I realised I could satisfy my yearning without too much soldering.

I decided that I would run Brad Rodriguez's Camelforth on it. Before I did that I resussitated a 6809 emulator and added crude support first for Brad's "scroungmaster" machine and then for the 6809 multicomp machine. That emulator is exec09.

Camelforth is currently running on real hardware. Using a hardware bank-switching unit on multicomp Camelforth can also act as boot loader for Grant's port of Microsoft ROM BASIC and for the N8VEM port of Dave Dunfield's CUBIX. All of this also runs on exec09.

This repository is a venue for sharing the hardware and software that I have used on my multicomp.

More on Camelforth here:
https://launchpad.net/camelforth
http://www.camelforth.com/
http://www.bradrodriguez.com/papers/index.html
