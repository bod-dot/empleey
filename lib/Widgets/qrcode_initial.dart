import 'package:flutter/material.dart';

import '../helper/constans.dart';

class QrcodeInitial extends StatelessWidget {
  const QrcodeInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.assignment_ind_outlined,
                              size: 50, color: kColorPrimer),
                          const SizedBox(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      'QR قم بتوجيه الكاميرا نحو الـ\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimer,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        ' الموجود في عداد الكهرباء\n' , style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimer,
                                    fontSize: 20,
                                  ),),
                              ],
                            ),
                          ),
                        ],
                      );
  }
}