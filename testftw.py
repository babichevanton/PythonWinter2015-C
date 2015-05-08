import cftw

def ftw_callback (path, stat, typeflag):
    # Print info only for directories
    if typeflag == cftw.FTW_D:
        print path, "uid = ", stat.pst_uid, "guid = ", stat.pst_gid
    return 0

def nftw_callback (path, stat, typeflag, ftwbuf):
    # Print info only for directories
    if typeflag == cftw.FTW_D:
        print path, "base = ", ftwbuf.base, "level = ", ftwbuf.level
    return cftw.FTW_CONTINUE

filetreewolker = cftw.Ftw()
filetreewolker.ftw("~", ftw_callback, 1)
print ""
filetreewolker.nftw("~", nftw_callback, 1, ftwpy.FTW_ACTIONRETVAL)