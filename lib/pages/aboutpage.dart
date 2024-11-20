import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        surfaceTintColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'I created taskflow with the idea that while many platforms focus on team collaboration, there are fewer tools designed for tracking individual progress. taskflow is built for personal use, helping users stay organized and productive by creating tasks, setting deadlines, and tracking progress effortlessly.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 200,
                        minHeight: 200,
                      ),
                      child: Image.asset(
                        'assets/monke.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Column(
              children: [
                const Text(
                  'Soham Sangole',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Social Links:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () {
                        launchUrl(Uri.parse(
                            'https://www.linkedin.com/in/sohamsangole/'));
                      },
                      color: Colors.white,
                    ),
                    const Text(
                      'LinkedIn',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () {
                        launchUrl(Uri.parse('https://github.com/sohamsangole'));
                      },
                      color: Colors.white,
                    ),
                    const Text(
                      'GitHub',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Email: sohamajaysangole@gmail.com',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
