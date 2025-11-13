

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ClipService{
  ClipService();

  Future<List<FileObject>> getClips() async{
    final clips = await Supabase.instance.client.storage.from('clips').list();

    return clips;
  }

  Future uploadClip(File file) async{
    await Supabase.instance.client.storage.from('clips').upload('videos', file);
  }

}