library opengraph;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:opengraph/entities/open_graph_entity.dart';

import 'fetch_opengraph.dart';

class OpenGraphPreview extends StatelessWidget {
  final String url;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color progressColor;
  final bool showReloadButton;
  const OpenGraphPreview({super.key, required this.url, this.height = 200, this.borderRadius = 10, this.backgroundColor = Colors.black87, this.progressColor = Colors.white54, this.showReloadButton = false});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: FutureBuilder(
          future: OpenGraphRequest.fetch(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: height,
                  color: backgroundColor,
                  child: Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ))
              );
            }

            if (snapshot.hasError) {
              return Container(
                  height: height,
                  color: backgroundColor,
                  child: Center(child: Text("Error al cargar la vista previa"))
              );
            }

            final data = snapshot.data as OpenGraphEntity;
            return SizedBox(
              height: height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  if(data.image != "")Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: EdgeInsets.all(borderRadius/2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius/2),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  if(data.title!="")Text(data.title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  if(data.description!="")Text(data.title, style: TextStyle(color: Colors.white, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(Uri.parse(data.url).host, style: TextStyle(color: Colors.white54)),
                                  if(showReloadButton)Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Vista previa",  style: TextStyle(color: Colors.white)),
                                      GestureDetector(
                                        onTap: (){
                                          OpenGraphRequest.fetch(url);
                                        },
                                          child: Text("Recargar", style: TextStyle(color: Colors.white))
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  )
                  // Agrega aquí cualquier otro widget necesario para mostrar la vista previa
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

