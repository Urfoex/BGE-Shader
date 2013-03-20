import subprocess
import os
import bpy
import shutil
import urllib.request
import time
import zipfile


bl_info = {
    "name": "Shader Repository",
    "description": "Gets GLSL Shader from a repository.",
    "author": "Manuel Bellersen (Urfoex)",
    "version": (0, 5),
    "blender": (2, 66, 0),
    "location": "File > Import > GLSL Shader Repository",
    "warning": "Be sure to have Mercurial installed if you don't use zipped version.",  # used for warning icon and text in addons panel
    "wiki_url": "https://bitbucket.org/Urfoex/bge-shader",
    "tracker_url": "https://bitbucket.org/Urfoex/bge-shader",
    "category": "Game Engine"
}


class GLSLShaderRepositoryPreferences(bpy.types.AddonPreferences):
    bl_idname = __name__
    use_zip = bpy.props.BoolProperty(name="Use ZIPped Version", default=True)

    def draw(self, context):
        layout = self.layout
        layout.label(text="Do you want to get the ZIPped or the Mercurial version?")
        layout.prop(self, "use_zip")


class GLSLShaderRepository(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository"
    bl_label = "Import GLSL Shader Repository"
    bl_options = {'REGISTER'}

    _REPO_OBJECTS = {}
    _REPO_OBJECTS['repository_src'] = "https://bitbucket.org/Urfoex/bge-shader"
    _REPO_OBJECTS['repository_folder'] = "bge-shader"
    _REPO_OBJECTS['repository_dest'] = bpy.utils.script_paths()[1]
    _REPO_OBJECTS['repository'] = _REPO_OBJECTS['repository_dest'] + os.sep + _REPO_OBJECTS['repository_folder']
    _REPO_OBJECTS['script_file'] = "GLSLShaderRepository.py"
    _REPO_OBJECTS['script_src'] = _REPO_OBJECTS['repository'] + os.sep + _REPO_OBJECTS['script_file']
    _REPO_OBJECTS['script_dest'] = _REPO_OBJECTS['repository_dest'] + os.sep + "addons" + os.sep + _REPO_OBJECTS['script_file']
    _REPO_OBJECTS['template_path'] = "startup" + os.sep + "bl_ui"
    _REPO_OBJECTS['template_file'] = "space_text.py"
    _REPO_OBJECTS['template_src'] = _REPO_OBJECTS['repository'] + os.sep + _REPO_OBJECTS['template_file']
    _REPO_OBJECTS['template_dest'] = bpy.utils.script_paths(_REPO_OBJECTS['template_path'])[0] + os.sep + _REPO_OBJECTS['template_file']
    _REPO_OBJECTS['template_orig'] = bpy.utils.script_paths(_REPO_OBJECTS['template_path'])[0] + os.sep + _REPO_OBJECTS['template_file'] + ".orig"
    _REPO_OBJECTS['repository_zip_file'] = "default.zip"
    _REPO_OBJECTS['repository_zip'] = "https://bitbucket.org/Urfoex/bge-shader/get/" + _REPO_OBJECTS['repository_zip_file']
    _REPO_OBJECTS['local_zip'] = _REPO_OBJECTS['repository_dest'] + os.sep + _REPO_OBJECTS['repository_zip_file']
    _REPO_OBJECTS['local_zip_extracted'] = _REPO_OBJECTS['repository_dest'] + os.sep + "shader" + os.sep
    _REPO_OBJECTS['shader'] = ["vertex", "fragment", "geometry", "postprocessing"]

    def __del__(self):
        self.clean_up()

    def clean_up(self):
        if os.path.exists(self._REPO_OBJECTS['template_orig']):
            print("--- Restoring:", self._REPO_OBJECTS['template_orig'], "to:", self._REPO_OBJECTS['template_dest'], "---")
            shutil.move(src=self._REPO_OBJECTS['template_orig'], dst=self._REPO_OBJECTS['template_dest'])
        if os.path.exists(self._REPO_OBJECTS['repository']):
            print("--- Removing:", self._REPO_OBJECTS['repository'], "---")
            shutil.rmtree(path=self._REPO_OBJECTS['repository'])

    def invoke(self, context, event):
        print("--- invoke ---")
        start_time = time.clock()
        print("--- execute started at:", start_time, "---")
        return_code = self.execute(context)
        print("--- execute finished at:", time.clock(), "---")
        print("--- took about", time.clock() - start_time, "s ---")
        return return_code

    def execute(self, context):
        print("--- execute ---")
        user_preferences = context.user_preferences
        addon_prefs = user_preferences.addons[__name__].preferences
        print("--- Use ZIP:", addon_prefs.use_zip, "---")
        self.clean_up()

        if not addon_prefs.use_zip:
            self.do_mercurial()
        else:
            self.get_remote_zip()
            self.unzip_zip()
            self.move_zip_files()

        return {'FINISHED'}

    def do_mercurial(self):
        return_code = 0
        if not os.path.isdir(self._REPO_OBJECTS['repository']):
            print("--- Cloning:", self._REPO_OBJECTS['repository_src'], "to:", self._REPO_OBJECTS['repository'], "... ---")
            return_code = self.clone_repository()
        else:
            print("--- Updating repository at:", self._REPO_OBJECTS['repository'], "... ---")
            return_code += self.pull_repository()
            return_code += self.update_repository()
        if return_code != 0:
            print("--- Please check the repository at:", self._REPO_OBJECTS['repository'], "---")
        else:
            if not os.path.exists(self._REPO_OBJECTS['template_orig']):
                print("--- Saving:", self._REPO_OBJECTS['template_dest'], "to:", self._REPO_OBJECTS['template_orig'], "---")
                shutil.copy2(src=self._REPO_OBJECTS['template_dest'], dst=self._REPO_OBJECTS['template_orig'])

            print("--- Modifying template file at:", self._REPO_OBJECTS['template_dest'], "---")
            shutil.copy2(src=self._REPO_OBJECTS['template_src'], dst=self._REPO_OBJECTS['template_dest'])

            print("--- Modifying script file at:", self._REPO_OBJECTS['script_dest'], "---")
            shutil.copy2(src=self._REPO_OBJECTS['script_src'], dst=self._REPO_OBJECTS['script_dest'])

    def clone_repository(self):
        return subprocess.call(args=['hg', 'clone', self._REPO_OBJECTS['repository_src']], cwd=self._REPO_OBJECTS['repository_dest'])

    def update_repository(self):
        return subprocess.call(args=['hg', 'update'], cwd=self._REPO_OBJECTS['repository'])

    def pull_repository(self):
        return subprocess.call(args=['hg', 'pull'], cwd=self._REPO_OBJECTS['repository'])

    def get_remote_zip(self):
        print("--- Importing zip from:", self._REPO_OBJECTS['repository_zip'], "---")
        remote_zip = urllib.request.urlopen(self._REPO_OBJECTS['repository_zip'])
        local_zip = open(self._REPO_OBJECTS['local_zip'], 'wb')
        local_zip.write(remote_zip.readall())
        local_zip.close()

    def unzip_zip(self):
        print("--- Unzipping:", self._REPO_OBJECTS['local_zip'], "---")
        zip_file = zipfile.ZipFile(self._REPO_OBJECTS['local_zip'])
        zip_file.extractall(path=self._REPO_OBJECTS['local_zip_extracted'])
        zip_file.close()

    def move_zip_files(self):
        print("--- Moving folders to:", self._REPO_OBJECTS['repository'], "---")
        object_path = self._REPO_OBJECTS['local_zip_extracted']
        for subp  in os.listdir(path=object_path):
            subdir = object_path + os.sep + subp + os.sep
            for shader in self._REPO_OBJECTS['shader']:
                shader_source = subdir + shader
                shader_destination = self._REPO_OBJECTS['repository'] + os.sep + shader
                if os.path.exists(shader_destination):
                    shutil.rmtree(path=shader_destination)
                shutil.move(src=shader_source, dst=shader_destination)

            if not os.path.exists(self._REPO_OBJECTS['template_orig']):
                print("--- Saving:", self._REPO_OBJECTS['template_dest'], "to:", self._REPO_OBJECTS['template_orig'], "---")
                shutil.copy2(src=self._REPO_OBJECTS['template_dest'], dst=self._REPO_OBJECTS['template_orig'])

            tmp_src = subdir + self._REPO_OBJECTS['template_file']
            print("--- Modifying template file at:", self._REPO_OBJECTS['template_dest'], "---")
            shutil.copy2(src=tmp_src, dst=self._REPO_OBJECTS['template_dest'])

            script_src = subdir + self._REPO_OBJECTS['script_file']
            print("--- Modifying script file at:", self._REPO_OBJECTS['script_dest'], "---")
            shutil.copy2(src=script_src, dst=self._REPO_OBJECTS['script_dest'])

        shutil.rmtree(path=object_path)
        os.remove(self._REPO_OBJECTS['local_zip'])


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
