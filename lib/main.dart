import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => TextProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}

class TextProvider {
  TextProvider({this.json = ''});

  String json;
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Quill Editor'),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _controller = quill.QuillController.basic();

  void saveDocument() {
    final provider = context.read<TextProvider>();
    provider.json = jsonEncode(_controller.document.toDelta().toJson());
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReadPage()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          quill.QuillToolbar.basic(controller: _controller),
          Expanded(
            child: quill.QuillEditor.basic(
              controller: _controller,
              readOnly: false,
            ),
          ),
          ElevatedButton(onPressed: saveDocument, child: Text('Save')),
          Spacer()
        ],
      ),
    );
  }
}

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  quill.QuillController _controller = quill.QuillController.basic();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final textProvider = context.read<TextProvider>();
    _controller = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(textProvider.json)),
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read the article you read'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: quill.QuillEditor(
          showCursor: false,
          controller: _controller,
          readOnly: true,
          autoFocus: false,
          scrollable: true,
          focusNode: FocusNode(),
          expands: true,
          scrollController: ScrollController(),
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
