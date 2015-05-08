cimport cftw

__doc__ = 'Primitive ftw.h wrapper'

cpdef enum:
    FTW_F,
    FTW_D,  
    FTW_DNR,
    FTW_NS, 
    FTW_SL,
    FTW_DP,
    FTW_SLN   

cpdef enum:
    FTW_PHYS = 1,           # Perform physical walk, ignore symlinks.  
    FTW_MOUNT = 2,          # Report only files on same file system as the argument.  
    FTW_CHDIR = 4,          # Change to current directory while processing it.  
    FTW_DEPTH = 8,          # Report files in directory before directory itself.
    FTW_ACTIONRETVAL = 16   # Assume callback to return FTW_* values instead of zero to continue and non-zero to terminate.


cdef class PyFTW:
    cdef init(self, cftw.FTW* ftwbuf):
        self.base = ftwbuf.base
        self.level = ftwbuf.level

    cdef get(self, cftw.FTW* ftwbuf):
        ftwbuf.base = self.base
        ftwbuf.level = self.level


cdef class PyStat:
    cdef init(self, const cftw.stat* sb):
        self.pst_dev = sb.st_dev
        self.pst_ino = sb.st_ino
        self.pst_mode = sb.st_mode
        self.pst_nlink = sb.st_nlink
        self.pst_uid = sb.st_uid
        self.pst_gid = sb.st_gid
        self.pst_rdev = sb.st_rdev
        self.pst_size = sb.st_size
        self.pst_blksize = sb.st_blksize
        self.pst_blocks = sb.st_blocks
        self.pst_atime = sb.st_atime
        self.pst_mtime = sb.st_mtime
        self.pst_ctime = sb.st_ctime


cdef object global_ftw_callback
cdef int ftw_callback(const char *fpath, const cftw.stat *sb, int typeflag):
    global global_ftw_callback

    stat = PyStat().init(sb)
    ret = global_ftw_callback(fpath, stat, typeflag)
    return -1 if ret is None else ret


cdef object global_nftw_callback
cdef int nftw_callback(const char *fpath, const cftw.stat *sb, int typeflag, cftw.FTW *ftwbuf):
    global global_nftw_callback

    stat = PyStat().init(sb)
    t_ftwbuf = PyFTW().init(ftwbuf)
    ret = global_nftw_callback(fpath, stat, typeflag, t_ftwbuf)    
    t_ftwbuf.get(ftwbuf)
    return -1 if ret is None else ret

cdef class Ftw:
    'ftw.h wrapper class'

    def ftw(self, const char *dirpath, object callback, int nopenfd):
        global global_ftw_callback, ftw_callback
        global_ftw_callback = callback
        cftw.ftw(dirpath, ftw_callback, nopenfd)

    def nftw(self, const char *dirpath, object callback, int nopenfd, int flags):
        global global_nftw_callback, nftw_callback
        global_nftw_callback = callback
        cftw.nftw(dirpath, nftw_callback, nopenfd, flags)
