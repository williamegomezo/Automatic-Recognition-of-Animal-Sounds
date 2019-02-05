import os


class DirUtils:
    def create_dir(self, filepath):
        folders = filepath.split('/')
        acu_folder = ''
        for folder in folders:
            acu_folder += folder + '/'
            try:
                os.mkdir(acu_folder)
            except:
                pass
