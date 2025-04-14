import zipfile

def main():
    print("Inside main")
    parent_file = "Eternal Loop.zip"
    pswd = 'hackthebox'

    with zipfile.ZipFile(parent_file, 'r') as pfl:
        pfl.extractall(pwd = bytes(pswd, 'utf-8'))

        nzfile = pfl.namelist()[0]
        # print(nzfile)
        while True:
            print("Next File: " + nzfile)
            if zipfile.is_zipfile(nzfile):
                with zipfile.ZipFile(nzfile) as zfile:
                    childfile = zfile.namelist()[0]
                    pswd = bytes(childfile.split('.')[0], 'utf-8')
                    zfile.extractall(pwd = pswd)
                    nzfile = childfile
            else:
                break

if __name__ == '__main__':
    print("what the hell")
    main()
