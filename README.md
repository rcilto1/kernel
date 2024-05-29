# horcrux-kernel



## Getting started

To clone this project run:

```
git clone PROJECT_URL
git submodule init
git submodule update
```

## Compiling the package

To compile the package, run:
```
./build_package.sh
```

# Working with kernel-workflow(kw)

The step-by-step process to contribute to the Linux kernel is listed below. Each of these items is a subsection:
- Find the right tree to work;
- Find and fix a problem;
- Use the *checkpatch* script;
- Test;
- Commit your chances with a descritive message;
- Send your commit to the proper maintainer.

## Find the right tree to work;

To find the right tree you must:
- Determine which kernel subsystem you want to contrib to;
- Find its git repo;
- Clone it.

### Determine which kernel subsystem you want to contrib to

A **kernel subsystem** is a portion of the kernel dedicated exclusively for a determined porpuse. For instance, CD-ROM, Networking... You may find a list and documentation of each kernel subsystem [here](https://docs.kernel.org/subsystem-apis.html).

As a example, we will choose to contrib to the **crypto** subsystem, which is the subsystem responsible for cryptography in the kernel.

### Find its git repo

The source code of the linux kernel is located in its [git repo](https://git.kernel.org/). By accessing this site, you may find a table with five columns: Name, Description, Owner, Idle and Links. Each line of this table is a git repo owned by a maintainer of a determined kernel subsystem. 

For example, if you search 'crypto' using the search bar in the right side of the page, you will find the line:

| Name | Description | Owner |
|:------|:-----------|:-----|
|kernel/git/herbert/crypto-2.6.git|Crypto API 2.6|Herbert Xu|

Herbert Xu is the maintainer of the crypto subsystem (I will show you how to check this) and he uses this git repo to work. If you want to contrib to this subsystem you must clone this repo by running
```
git clone https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/ --depth=1
```
Then you must `switch` to the most recent branch.

The source tree for Power Management and ACPI is https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/

### The mainline

The git repo owned by Linus Torvalds and used for releasing which version of the kernel is called **mainline**. You can find it by searching 'Linus' in https://git.kernel.org/ or by clicking https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/.


## Find and fix a problem;
After cloning the project, you can use the *checkpatch* script.



## Test;
## Commit your chances with a descritive message;
## Send your commit to the proper maintainer.
