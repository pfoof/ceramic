package ceramic;

import ceramic.Path;
import ceramic.Shortcuts.*;

class SoundAsset extends Asset {

    /// Events

    @event function replaceSound(newSound:Sound, prevSound:Sound);

    public var stream:Bool = false;

    @observe public var sound:Sound = null;

    override public function new(name:String, ?options:AssetOptions #if ceramic_debug_entity_allocs , ?pos:haxe.PosInfos #end) {

        super('sound', name, options #if ceramic_debug_entity_allocs , pos #end);

    }

    override public function load() {

        status = LOADING;

        if (path == null) {
            log.warning('Cannot load sound asset if path is undefined.');
            status = BROKEN;
            emitComplete(false);
            return;
        }

        var loadOptions:AssetOptions = {};
        if (owner != null) {
            loadOptions.immediate = owner.immediate;
            loadOptions.loadMethod = owner.loadMethod;
        }
        if (options != null) {
            for (key in Reflect.fields(options)) {
                Reflect.setField(loadOptions, key, Reflect.field(options, key));
            }
        }

        // Add reload count if any
        var remainingPaths = [].concat(allPaths);

        function handleBackendResponse(audio:backend.AudioResource) {

            if (audio != null) {

                var prevSound = this.sound;

                var newSound = new Sound(audio);
                newSound.asset = this;
                this.sound = newSound;

                if (prevSound != null) {
                    // When replacing the sound, emit an event to notify about it
                    emitReplaceSound(this.sound, prevSound);

                    // Destroy previous sound
                    prevSound.asset = null;
                    prevSound.destroy();
                }

                status = READY;
                emitComplete(true);
            }
            else {
                status = BROKEN;
                log.error('Failed to load audio at path: $path');
                emitComplete(false);
            }

        }

        function doLoad(path:String) {

            var backendPath = path;
            var realPath = Assets.realAssetPath(backendPath, runtimeAssets);
            var assetReloadedCount = Assets.getReloadCount(realPath);
            if (app.backend.texts.supportsHotReloadPath() && assetReloadedCount > 0) {
                realPath += '?hot=' + assetReloadedCount;
                backendPath += '?hot=' + assetReloadedCount;
            }

            log.info('Load sound $backendPath');

            var ext = ceramic.Path.extension(realPath);
            if (ext != null)
                ext = ext.toLowerCase();

            app.backend.audio.load(realPath, loadOptions, function(audio) {

                if (audio != null || remainingPaths.length == 0) {
                    handleBackendResponse(audio);
                }
                else {
                    var nextPath = remainingPaths.shift();
                    log.warning('Failed to load $path. Try $nextPath...');
                    doLoad(nextPath);
                }

            });

        }

        if (remainingPaths.length > 0)
            doLoad(remainingPaths.shift());
        else {
            status = BROKEN;
            log.error('Failed to load audio at path: $path');
            emitComplete(false);
        }

    }

    override function assetFilesDidChange(newFiles:ReadOnlyMap<String, Float>, previousFiles:ReadOnlyMap<String, Float>):Void {

        if (!app.backend.audio.supportsHotReloadPath())
            return;

        var previousTime:Float = -1;
        if (previousFiles.exists(path)) {
            previousTime = previousFiles.get(path);
        }
        var newTime:Float = -1;
        if (newFiles.exists(path)) {
            newTime = newFiles.get(path);
        }

        if (newTime > previousTime) {
            log.info('Reload sound (file has changed)');
            load();
        }

    }

    override function destroy():Void {

        super.destroy();

        if (sound != null) {
            sound.destroy();
            sound = null;
        }

    }

}
