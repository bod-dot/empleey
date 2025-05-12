import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:this_is_tayrd/cubit/login_cubit/login_cubit.dart';
import 'package:this_is_tayrd/helper/constans.dart';
import '../../../models/ares.dart';
//this
class Mydropdown extends StatefulWidget {
  final List<Area> areaList;

  const Mydropdown({
    super.key,
    required this.areaList,
  });

  @override
  State<Mydropdown> createState() => _MydropdownState();
}

class _MydropdownState extends State<Mydropdown> {
  int? selectedAreaID;

  @override
  void initState() {
    super.initState();
    if (widget.areaList.isNotEmpty) {
      selectedAreaID = widget.areaList.first.areaID;
     
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      
        Expanded(
          child: DropdownButtonFormField<int>(
            menuMaxHeight: 250,
            decoration: InputDecoration(
              
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kColorPrimer, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            value: selectedAreaID,
            icon: const Icon(Icons.arrow_drop_down, color: kColorPrimer),
            style: const TextStyle(
              overflow: TextOverflow.visible,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kColorPrimer,
            ),
            
            items: widget.areaList.map((Area area) {
              return DropdownMenuItem<int>(
                value: area.areaID,
               
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    area.areaName,
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                
                setState(() {
                  selectedAreaID = newValue;
                  BlocProvider.of<LoginCubitCubit>(context).areaId=selectedAreaID!;
                });
              }
            },
           
            iconSize: 30,
            elevation: 16,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}