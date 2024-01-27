import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewMessageBar extends StatelessWidget {
  const NewMessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(padding: const EdgeInsets.only(left: 1,right: 1,bottom: 1, top: 4),
    
      child:Container(
        color:Colors.white,
        child: Row(
          
          children: [
           IconButton(onPressed: (){}, icon: Icon(Icons.photo),
           color: const Color.fromRGBO(55, 94, 152, 1),
           ),
          const Expanded(child: TextField(
             keyboardType: TextInputType.multiline,
            //  onChanged: (){

            //  },
            maxLines: null,
            decoration: const InputDecoration(labelText: 'أدخل رسالتك'),
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
          ),
          ),
          
          IconButton(onPressed: (){

          }, icon: Icon(Icons.send),
         
          color: const Color.fromRGBO(55, 94, 152, 1),
          ),
      
      
        ],),
      ) ,
      ),
    );
  }
}