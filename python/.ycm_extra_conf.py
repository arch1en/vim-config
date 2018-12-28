import os
import os.path
import fnmatch
import logging
import ycm_core
import re

MSVCPATH = 'C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.13.26128'
UEPATH   = 'C:/_Engines/UE_4.20'
PROJECTPATH = 'C:/_Workspace/BeBee'

BASE_FLAGS = \
[
    '-std=c++14',
    '-Wall',
    '-Wextra',
    '-Weffc++',
    '-Wfloat-equal',
    '-Winit-self',
    '-Wuninitialized',
    '-ferror-limit=5',

    '-xc++',
    '-DNDEBUG',
    '-pedantic',

    '-I', 'C:/Users/Adam/MyStuff/Share/include',
    '-I', 'C:/_Workspace/BeBee/Source/',
	
    '-isystem', MSVCPATH + '/include',

    '-isystem', UEPATH + '/Engine/Source/Runtime',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Advertising/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AIModule/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ALAudio/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Analytics/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Android/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AnimationCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AnimGraphRuntime/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AppFramework/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Apple/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ApplicationCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AssetRegistry/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AudioMixer/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AudioPlatformConfiguration/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AugmentedReality/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AutomationMessages/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AutomationWorker/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AVIWriter/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/BlueprintRuntime/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/BuildSettings/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/CEF3Utils/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/CinematicCamera/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ClientPilot/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ClothingSystemRuntime/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ClothingSystemRuntimeInterface/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/CookedIterativeFile/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Core/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/CoreUObject/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/D3D12RHI/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/DatabaseSupport/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/EmptyRHI/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Engine/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/EngineMessages/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/EngineSettings/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/EyeTracker/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Foliage/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/FriendsAndChat/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/GameMenuBuilder/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/GameplayTags/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/GameplayTasks/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/HardwareSurvey/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/HeadMountedDisplay/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/HTML5/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ImageCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ImageWrapper/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/InputCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/InputDevice/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/IOS/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/IPC/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Json/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/JsonUtilities/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Landscape/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Launch/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/LevelSequence/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Linux/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/LiveLinkInterface/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/LiveLinkMessageBusFramework/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Lumin/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Mac/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MaterialShaderQualitySettings/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Media/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MediaAssets/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MediaIOCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MediaUtils/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MeshDescription/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Messaging/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MessagingCommon/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MessagingRpc/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MoviePlayer/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MovieScene/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MovieSceneCapture/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MovieSceneTracks/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MRMesh/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/NavigationSystem/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Navmesh/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/NetworkFile/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/NetworkFileSystem/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Networking/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/NetworkReplayStreaming/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/NullDrv/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Online/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/OpenGLDrv/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Overlay/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PacketHandlers/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PakFile/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PerfCounters/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PhysXCooking/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Portal/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Projects/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PropertyPath/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/RenderCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Renderer/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/RHI/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/RuntimeAssetCache/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SandboxFile/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Serialization/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SessionMessages/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SessionServices/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/ShaderCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Slate/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SlateCore/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SlateNullRenderer/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SlateRHIRenderer/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Sockets/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/StreamingFile/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/StreamingPauseRendering/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/SynthBenchmark/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/TimeManagement/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Toolbox/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/UE4Game/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/UMG/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Unix/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/UnrealAudio/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/UtilityShaders/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/VectorVM/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/VulkanRHI/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/WebBrowser/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/WebBrowserTexture/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/WidgetCarousel/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Windows/Public',
    '-isystem', UEPATH + '/Engine/Source/Runtime/XmlParser/Public',

    '-isystem', UEPATH + '/Engine/Source/Runtime/AIModule/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Analytics/AnalyticsVisualEditing/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Android/AndroidRuntimeSettings/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/AudioMixer/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Engine/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/EngineSettings/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/GameplayTags/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/GameplayTasks/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/InputCore/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/IOS/IOSRuntimeSettings/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/IOS/LaunchDaemonMessages/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Landscape/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/Lumin/LuminRuntimeSettings/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/MaterialShaderQualitySettings/Classes',
    '-isystem', UEPATH + '/Engine/Source/Runtime/PacketHandlers/PacketHandler/Classes',
	
	'-isystem', PROJECTPATH + '/Source'
]

SOURCE_EXTENSIONS = \
[
    '.cpp',
    '.cc',
    '.c'
]

SOURCE_DIRECTORIES = \
[
    'src',
    'lib'
]

HEADER_EXTENSIONS = \
[
    '.hpp',
    '.h',
    '.hh'
]

HEADER_DIRECTORIES = \
[
    'include'
]

def Settings( **kwargs ):
  if kwargs[ 'language' ] == 'cfamily':
    # If the file is a header, try to find the corresponding source file and
    # retrieve its flags from the compilation database if using one. This is
    # necessary since compilation databases don't have entries for header files.
    # In addition, use this source file as the translation unit. This makes it
    # possible to jump from a declaration in the header file to its definition
    # in the corresponding source file.
    filename = FindCorrespondingSourceFile( kwargs[ 'filename' ] )

    if not database:
      return {
        'flags': flags,
        'include_paths_relative_to_dir': DIR_OF_THIS_SCRIPT,
        'override_filename': filename
      }

    compilation_info = database.GetCompilationInfoForFile( filename )
    if not compilation_info.compiler_flags_:
      return {}

    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object.
    final_flags = list( compilation_info.compiler_flags_ )

    # NOTE: This is just for YouCompleteMe; it's highly likely that your project
    # does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
    # ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
    try:
      final_flags.remove( '-stdlib=libc++' )
    except ValueError:
      pass

    return {
      'flags': final_flags,
      'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
      'override_filename': filename
    }
  return {}

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS

def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            # Get info from the source files by replacing the extension.
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
            # If that wasn't successful, try replacing possible header directory with possible source directories.
            for header_dir in HEADER_DIRECTORIES:
                for source_dir in SOURCE_DIRECTORIES:
                    src_file = replacement_file.replace(header_dir, source_dir)
                    if os.path.exists(src_file):
                        compilation_info = database.GetCompilationInfoForFile(src_file)
                        if compilation_info.compiler_flags_:
                            return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)

def FindNearest(path, target, build_folder):
    candidate = os.path.join(path, target)
    if(os.path.isfile(candidate) or os.path.isdir(candidate)):
        logging.info("Found nearest " + target + " at " + candidate)
        return candidate;

    parent = os.path.dirname(os.path.abspath(path));
    if(parent == path):
        raise RuntimeError("Could not find " + target);

    if(build_folder):
        candidate = os.path.join(parent, build_folder, target)
        if(os.path.isfile(candidate) or os.path.isdir(candidate)):
            logging.info("Found nearest " + target + " in build folder at " + candidate)
            return candidate;

    return FindNearest(parent, target, build_folder)

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[ len(path_flag): ]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForClangComplete(root):
    try:
        clang_complete_path = FindNearest(root, '.clang_complete')
        clang_complete_flags = open(clang_complete_path, 'r').read().splitlines()
        return clang_complete_flags
    except:
        return None

def FlagsForInclude(root):
    try:
        include_path = FindNearest(root, 'include')
        flags = []
        for dirroot, dirnames, filenames in os.walk(include_path):
            for dir_path in dirnames:
                real_path = os.path.join(dirroot, dir_path)
                flags = flags + ["-I" + real_path]
        return flags
    except:
        return None

def FlagsForCompilationDatabase(root, filename):
    try:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = FindNearest(root, 'compile_commands.json', 'build')
        compilation_db_dir = os.path.dirname(compilation_db_path)
        logging.info("Set compilation database directory to " + compilation_db_dir)
        compilation_db =  ycm_core.CompilationDatabase(compilation_db_dir)
        if not compilation_db:
            logging.info("Compilation database file found but unable to load")
            return None
        compilation_info = GetCompilationInfoForFile(compilation_db, filename)
        if not compilation_info:
            logging.info("No compilation info for " + filename + " in compilation database")
            return None
        return MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)
    except:
        return None

def FlagsForFile(filename):
    root = os.path.realpath(filename);
    compilation_db_flags = FlagsForCompilationDatabase(root, filename)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        final_flags = BASE_FLAGS
        clang_flags = FlagsForClangComplete(root)
        if clang_flags:
            final_flags = final_flags + clang_flags
        include_flags = FlagsForInclude(root)
        if include_flags:
            final_flags = final_flags + include_flags
    return {
            'flags': final_flags,
            'do_cache': True
            }