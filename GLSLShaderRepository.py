import subprocess
import os
import bpy
import shutil


bl_info = {
    "name": "Shader Repository",
    "description": "Gets GLSL Shader from a repository.",
    "author": "Manuel Bellersen (Urfoex)",
    "version": (0, 4),
    "blender": (2, 66, 0),
    "location": "File > Import > GLSL Shader Repository",
    "warning": "Be sure to have Mercurial installed if you don't use zipped version.",  # used for warning icon and text in addons panel
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
gRepoObjects['script_file_zip'] = "GLSLShaderRepositoryZIP.py"
gRepoObjects['script_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['script_file']
gRepoObjects['script_dest'] = gRepoObjects['repository_dest'] + os.sep + "addons" + os.sep + gRepoObjects['script_file']
gRepoObjects['template_path'] = "startup" + os.sep + "bl_ui"
gRepoObjects['template_file'] = "space_text.py"
gRepoObjects['template_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_dest'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_orig'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file'] + ".orig"
gRepoObjects['repository_zip_file'] = "default.zip"
gRepoObjects['repository_zip'] = "https://bitbucket.org/Urfoex/bge-shader/get/" + gRepoObjects['repository_zip_file']
gRepoObjects['local_zip'] = gRepoObjects['repository_dest'] + os.sep + gRepoObjects['repository_zip_file']
gRepoObjects['local_zip_extracted'] = gRepoObjects['repository_dest'] + os.sep + "shader" + os.sep
gRepoObjects['shader'] = ["vertex", "fragment", "geometry", "postprocessing"]


class GLSLShaderRepositoryPreferences(bpy.types.AddonPreferences):
    bl_idname = __name__

    useZip = bpy.props.BoolProperty(name="Use ZIPped Version", default=True)

    def draw(self, context):
        layout = self.layout
        layout.label(text="Do you want to get the ZIPped or the Mercurial version?")
        layout.prop(self, "useZip")


class GLSLShaderRepository(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository"
    bl_label = "Import GLSL Shader Repository"
    bl_options = {'REGISTER'}

    def __del__(self):
        self.CleanUp()

    def CleanUp(self):
        if os.path.exists(gRepoObjects['template_orig']):
            print("--- Restoring:", gRepoObjects['template_orig'], "to:", gRepoObjects['template_dest'], "---")
            shutil.move(src=gRepoObjects['template_orig'], dst=gRepoObjects['template_dest'])
        if os.path.exists(gRepoObjects['repository']):
            print("--- Removing:", gRepoObjects['repository'], "---")
            shutil.rmtree(path=gRepoObjects['repository'])

    def invoke(self, context, event):
        print("--- invoke ---")
        import time
        start_time = time.clock()
        print("--- execute started at:", start_time, "---")
        retCode = self.execute(context)
        print("--- execute finished at:", time.clock(), "---")
        print("--- took about", time.clock() - start_time, "s ---")
        return retCode

    def execute(self, context):
        print("--- execute ---")
        user_preferences = context.user_preferences
        addon_prefs = user_preferences.addons[__name__].preferences
        print("--- Use ZIP:", addon_prefs.useZip, "---")
        self.CleanUp()

        if not addon_prefs.useZip:
            self.DoMercurial()
        else:
            self.getRemoteZIP()
            self.unzipZIP()
            self.moveZIPFiles()

        return {'FINISHED'}

    def DoMercurial(self):
        retCode = 0
        if not os.path.isdir(gRepoObjects['repository']):
            print("Cloning:", gRepoObjects['repository_src'], "to:", gRepoObjects['repository'], "...")
            retCode = self.CloneRepository()
        else:
            print("Updating repository at:", gRepoObjects['repository'], "...")
            retCode += self.PullRepository()
            retCode += self.UpdateRepository()
        if retCode != 0:
            print("Please check the repository at:", gRepoObjects['repository'])
        else:
            if not os.path.exists(gRepoObjects['template_orig']):
                print("Saving:", gRepoObjects['template_dest'], "to:", gRepoObjects['template_orig'])
                shutil.copy2(src=gRepoObjects['template_dest'], dst=gRepoObjects['template_orig'])

            print("Modifying template file at:", gRepoObjects['template_dest'])
            shutil.copy2(src=gRepoObjects['template_src'], dst=gRepoObjects['template_dest'])

            print("Modifying script file at:", gRepoObjects['script_dest'])
            shutil.copy2(src=gRepoObjects['script_src'], dst=gRepoObjects['script_dest'])

    def CloneRepository(self):
        return subprocess.call(args=['hg', 'clone', gRepoObjects['repository_src']], cwd=gRepoObjects['repository_dest'])

    def UpdateRepository(self):
        return subprocess.call(args=['hg', 'update'], cwd=gRepoObjects['repository'])

    def PullRepository(self):
        return subprocess.call(args=['hg', 'pull'], cwd=gRepoObjects['repository'])

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

    def moveZIPFiles(self):
        print("Moving folders to:", gRepoObjects['repository'])
        p = gRepoObjects['local_zip_extracted']
        for subp  in os.listdir(path=p):
            subdir = p + os.sep + subp + os.sep
            for shader in gRepoObjects['shader']:
                shaderSrc = subdir + shader
                shaderDst = gRepoObjects['repository'] + os.sep + shader
                if os.path.exists(shaderDst):
                    shutil.rmtree(path=shaderDst)
                shutil.move(src=shaderSrc, dst=shaderDst)

            if not os.path.exists(gRepoObjects['template_orig']):
                print("Saving:", gRepoObjects['template_dest'], "to:", gRepoObjects['template_orig'])
                shutil.copy2(src=gRepoObjects['template_dest'], dst=gRepoObjects['template_orig'])

            tmp_src = subdir + gRepoObjects['template_file']
            print("Modifying template file at:", gRepoObjects['template_dest'])
            shutil.copy2(src=tmp_src, dst=gRepoObjects['template_dest'])

            script_src = subdir + gRepoObjects['script_file_zip']
            print("Modifying script file at:", gRepoObjects['script_dest'])
            shutil.copy2(src=script_src, dst=gRepoObjects['script_dest'])

        shutil.rmtree(path=p)
        os.remove(gRepoObjects['local_zip'])


def menu_func(self, context):
    self.layout.operator(GLSLShaderRepository.bl_idname, text="GLSL Shader Repository")


def register():
    bpy.utils.register_class(GLSLShaderRepository)
    bpy.utils.register_class(GLSLShaderRepositoryPreferences)
    bpy.types.INFO_MT_file_import.append(menu_func)


def unregister():
    bpy.utils.unregister_class(GLSLShaderRepository)
    bpy.utils.unregister_class(GLSLShaderRepositoryPreferences)
    bpy.types.INFO_MT_file_import.remove(menu_func)


if __name__ == "__main__":
    register()
