import 'package:flutter/material.dart';
import 'package:sycs_proj_shikha/main.dart';
class Explore_More extends StatefulWidget {
  const Explore_More({super.key});

  @override
  State<Explore_More> createState() => _Explore_MoreState();
}

class _Explore_MoreState extends State<Explore_More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          onPressed: (){
            Navigator.pushNamed(context, "home");
          },
          icon: Icon(Icons.home,color: Colors.brown,),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: GridView.count(crossAxisCount: 2,
          children: [
            _getImage("https://rukminim2.flixcart.com/image/850/1000/jv5k2a80/painting/y/b/x/naag-228-d-new-anjani-art-gallery-original-imafg3t87g8sr2vy.jpeg?q=90&crop=false"),
            _getImage("https://rukminim2.flixcart.com/image/850/1000/l4d2ljk0/painting/i/p/e/13-5-1-bag-pf-0323-braj-art-gallery-original-imagf9zannnznjss.jpeg?q=90&crop=false"),
            _getImage("images/img1.jpg"),
            _getImage("https://5.imimg.com/data5/ZF/VX/GC/SELLER-20184695/modern-art-of-radha-krishan.jpeg"),
            _getImage("https://5.imimg.com/data5/SELLER/Default/2024/1/375505841/JE/ES/NC/55522247/shree-krishna-painting-with-silver-work.jpg"),
            _getImage("https://rukminim2.flixcart.com/image/850/1000/jy7kyvk0/painting/h/2/g/p0670-paf-original-imafhnggafz8fcrd.jpeg?q=20&crop=false"),
            _getImage("https://img.huffingtonpost.com/asset/56216c1a1400002b003c8777.jpeg?cache=bItG5koanL&ops=crop_0_111_772_693%2Cscalefit_720_noupscale"),
            _getImage("https://www.artisera.com/cdn/shop/files/Paintings_600x400.jpg?v=1613715757"),
            _getImage("https://rukminim2.flixcart.com/image/850/1000/jv5k2a80/painting/r/j/5/naag-203-e-new-anjani-art-gallery-original-imafg3rzdetxhgbc.jpeg?q=90&crop=false"),
            _getImage("https://raniartsandteak.co.in/cdn/shop/products/IMG_2718.jpg?v=1598702603"),
            _getImage("https://m.media-amazon.com/images/I/61rsjnH1+JL.jpg"),
            _getImage("https://miro.medium.com/v2/resize:fit:1080/1*jaqjMYGVCvDUKUzlYo4fSg.jpeg"),
            _getImage("images/img2.jpg"),
            _getImage("https://www.diamondartclub.com/cdn/shop/products/genius-billionaire-playboy-philanthropist-diamond-art-painting-33888589185217.jpg?v=1680445707&width=425"),
            _getImage("https://5.imimg.com/data5/TR/HR/NT/SELLER-47229742/modern-art-paintings.jpg"),
          ],
        ),
      ),
    );
  }
  Widget _getImage(String imageUrl){
    return Container(
      height: 100,
      width: 100,
      child: Image.network(imageUrl),
    );
  }
}
