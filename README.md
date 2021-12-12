# cool-compiler
Stanford COOL compiler implementation  
[Edx Course](https://learning.edx.org/course/course-v1:StanfordOnline+SOE.YCSCS1+2T2020/home)

# Environment setup 

## Step 1 - Basics
1. Follow the [Edx Linux setup guide](https://courses.edx.org/courses/course-v1:StanfordOnline+SOE.YCSCS1+2T2020/6b750292e90d4950b895f621a5671b49/), I used Ubuntu LTS 18 and virtual box.
2. Need to install 32 bit libc dev package, refer to [this](https://stackoverflow.com/questions/7412548/error-gnu-stubs-32-h-no-such-file-or-directory-while-compiling-nachos-source). For me, I simply `sudo apt-get install libc6-dev-i386`.
3. Try whether your coolc and spim works by [this](https://courses.edx.org/courses/course-v1:StanfordOnline+SOE.YCSCS1+2T2020/9f961242edfb45eba0969a5a7592916d).
4. Optionally can use install ssh server and start remote development. (e.g. [VSCode](https://code.visualstudio.com/docs/remote/ssh)).

## Step 2 - Flex
The initial Flex version inside Ubuntu is likely to be incompatible.
1. Remove old version `sudo apt remove flex`.
2. Download v2.5.35 from [here](https://src.fedoraproject.org/lookaside/pkgs/flex/flex-2.5.35.tar.bz2/10714e50cea54dc7a227e3eddcd44d57/)
3. Unwrap by `tar -xf flex-2.5.35.tar.bz2`, cd to the directory.
4. Then install by `./configure && make -j4 && sudo make install`.