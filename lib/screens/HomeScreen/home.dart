import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Reem Hatem'),
            // User level, confidence
            const SizedBox(height: 16),
            // Browse all courts banner
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/browse_courts.jpg'), // Add your image here
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Browse all courts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(context, 'Search Court', Icons.search),
                _buildButton(context, 'Support', Icons.support),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(context, 'My Bookings', Icons.book_online),
                _buildButton(context, 'Notifications', Icons.notifications),
              ],
            ),
            SizedBox(height: 16),
            // Favorites and upcoming matches
            Row(
              children: [
                Icon(Icons.favorite_border),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'My Favorites',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('You have no favorites'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.sports_tennis),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'My upcoming open matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('You have no upcoming open matches'),
            SizedBox(height: 16),
            // Browse all courts button
            // Center(
            //   child: ElevatedButton.icon(
            //     onPressed: () {},
            //     icon: Icon(Icons.search),
            //     label: Text('Browse all courts'),
            //     style: ElevatedButton.styleFrom(
            //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButton(BuildContext context, String label, IconData icon) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          // primary: Colors.white,
          // onPrimary: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ),
  );
}
