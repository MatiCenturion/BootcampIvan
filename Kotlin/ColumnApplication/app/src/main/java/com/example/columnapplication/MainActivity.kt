package com.example.columnapplication

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.columnapplication.ui.theme.ColumnApplicationTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            app()
        }
    }
}

@Preview
@Composable
fun app() {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Red)
    ) {
        item {
            Image(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(400.dp),
                painter = painterResource(id = R.drawable.imagivandep),
                contentDescription = "Logo IvanDevs"
            )
            Row(modifier = Modifier.padding(top = 8.dp)) {
                Image(
                    painter = painterResource(id = R.drawable.favorite),
                    contentDescription = "Like"
                )
            }

            Text(text = "1", color = Color.White, modifier = Modifier.padding(start = 4.dp))
            Text(
                text = "Ivan Devs",
                fontSize = 32.sp,
                color = Color.White,
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center
            )
            Text(
                text = "Prueba",
                textAlign = TextAlign.Center,
                fontSize = 32.sp,
                color = Color.White,
//            modifier = Modifier.fillMaxSize()
            )
            Text(
                text = "Hola",
                textAlign = TextAlign.Center,
                fontSize = 32.sp,
                color = Color.White,
//            modifier = Modifier.fillMaxSize()
            )
            LazyRow(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)

            ) {
                item {
                    Text(text = "Stack", color = Color.White)
                    Text(text = "Java", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                    Text(text = " Kotlin", color = Color.White)
                }

            }
        }
    }
}