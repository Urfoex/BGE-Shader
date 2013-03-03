import os
import bpy
import shutil


bl_info = {
    "name": "Shader Repository ZIP",
    "description": "Gets GLSL Shader zipped from a repository.",
    "author": "Manuel Bellersen (Urfoex)",
    "version": (0, 2),
    "blender": (2, 66, 0),
    "location": "File > Import > GLSL Shader Repository ZIP",
    "warning": "",  # used for warning icon and text in addons panel
    "wiki_url": "https://bitbucket.org/Urfoex/bge-shader",
    "tracker_url": "https://bitbucket.org/Urfoex/bge-shader",
    "category": "Game Engine"
}


gRepoObjects = {}
gRepoObjects['repository_src'] = "https://bitbucket.org/Urfoex/bge-shader"
gRepoObjects['repository_folder'] = "bge-shader"
gRepoObjects['repository_dest'] = bpy.utils.script_paths()[1]
gRepoObjects['repository'] = gRepoObjects['repository_dest'] + os.sep + gRepoObjects['repository_folder']
gRepoObjects['script_file'] = "GLSLShaderRepository.py"
gRepoObjects['script_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['script_file']
gRepoObjects['script_dest'] = gRepoObjects['repository_dest'] + os.sep + "addons" + os.sep + gRepoObjects['script_file']
gRepoObjects['template_path'] = "startup" + os.sep + "bl_ui"
gRepoObjects['template_file'] = "space_text.py"
gRepoObjects['template_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_dest'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_orig'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file'] + ".orig"
gRepoObjects['repository_zip'] = "https://bitbucket.org/Urfoex/bge-shader/get/default.zip"
gRepoObjects['local_zip'] = gRepoObjects['repository_dest'] + os.sep + "default.zip"
gRepoObjects['local_zip_extracted'] = gRepoObjects['repository_dest'] + os.sep + "shader" + os.sep
gRepoObjects['shader'] = ["vertex", "fragment", "geometry", "postprocessing"]


class GLSLShaderRepositoryZIP(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository_zip"
    bl_label = "Import GLSL Shader Repository ZIP"
    bl_options = {'REGISTER'}

    def __del__(self):
        None
        #if os.path.exists(gRepoObjects['template_orig']):
            #print("Restoring:", gRepoObjects['template_orig'], "to:", gRepoObjects['template_dest'])
            #shutil.move(src=gRepoObjects['template_orig'], dst=gRepoObjects['template_dest'])
        #if os.path.exists(gRepoObjects['repository']):
            #print("Removing:", gRepoObjects['repository'])
            #shutil.rmtree(path=gRepoObjects['repository'])

    # unused
    #def execute(self, context):
        #import time
        #start_time = time.clock()
        #print("execute started at:", start_time)
        #self.run()
        #print("execute finished at:", time.clock())
        #print("took about", time.clock() - start_time, "s")
        #return {'FINISHED'}

    def invoke(self, context, event):
        import time
        start_time = time.clock()
        print("execute started at:", start_time)
        self.run()
        print("execute finished at:", time.clock())
        print("took about", time.clock() - start_time, "s")
        return {'RUNNING_MODAL'}

    def getRemoteZIP(self):
        import urllib
        import urllib.request

        print("Importing zip from:", gRepoObjects['repository_zip'])
        remote_zip = urllib.request.urlopen(gRepoObjects['repository_zip'])
        local_zip = open(gRepoObjects['local_zip'], 'wb')
        local_zip.write(remote_zip.readall())
        local_zip.close()

    def unzipZIP(self):
        import zipfile
        print("Unzipping:", gRepoObjects['local_zip'])
        z = zipfile.ZipFile(gRepoObjects['local_zip'])
        z.extractall(path=gRepoObjects['local_zip_extracted'])
        z.close()
        None

    def moveZIPFiles(self):
        print("Moving folders to:", gRepoObjects['repository'])
        p = gRepoObjects['local_zip_extracted']
        for subp  in os.listdir(path=p):
            for shader in gRepoObjects['shader']:
                shaderSrc = p + os.sep + subp + os.sep + shader
                shaderDst = gRepoObjects['repository'] + os.sep + shader
                if os.path.exists(shaderDst):
                    shutil.rmtree(path=shaderDst)
                shutil.move(src=shaderSrc, dst=shaderDst)
        shutil.rmtree(path=p)

    def run(self):
        self.getRemoteZIP()
        self.unzipZIP()
        self.moveZIPFiles()
        return

        retCode = 0
        if not os.path.isdir(gRepoObjects['repository']):
            None
            #print("Cloning:", gRepoObjects['repository_src'], "to:", gRepoObjects['repository'], "...")
            #retCode = self.CloneRepository()
        else:
            None
            #print("Updating repository at:", gRepoObjects['repository'], "...")
            #retCode += self.PullRepository()
            #retCode += self.UpdateRepository()
        if retCode != 0:
            None
            #print("Please check the repository at:", gRepoObjects['repository'])
        else:
            None
            #if not os.path.exists(gRepoObjects['template_orig']):
                #print("Saving:", gRepoObjects['template_dest'], "to:", gRepoObjects['template_orig'])
                #shutil.copy2(src=gRepoObjects['template_dest'], dst=gRepoObjects['template_orig'])

            #print("Modifying template file at:", gRepoObjects['template_dest'])
            #shutil.copy2(src=gRepoObjects['template_src'], dst=gRepoObjects['template_dest'])

            #print("Modifying script file at:", gRepoObjects['script_dest'])
            #shutil.copy2(src=gRepoObjects['script_src'], dst=gRepoObjects['script_dest'])

    #def CloneRepository(self):
        #return subprocess.call(args=['hg', 'clone', gRepoObjects['repository_src']], cwd=gRepoObjects['repository_dest'])

    #def UpdateRepository(self):
        #return subprocess.call(args=['hg', 'update'], cwd=gRepoObjects['repository'])

    #def PullRepository(self):
        #return subprocess.call(args=['hg', 'pull'], cwd=gRepoObjects['repository'])


def menu_func(self, context):
    self.layout.operator(GLSLShaderRepositoryZIP.bl_idname, text="GLSL Shader Repository ZIP")


def register():
    bpy.utils.register_class(GLSLShaderRepositoryZIP)
    bpy.types.INFO_MT_file_import.append(menu_func)


def unregister():
    bpy.utils.unregister_class(GLSLShaderRepositoryZIP)
    bpy.types.INFO_MT_file_import.remove(menu_func)


if __name__ == "__main__":
    register()