package com.example.mvvmlogin.ui.theme.login.catchMeGame

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import kotlin.math.roundToInt

@Composable
fun Ball(ballOffset: androidx.compose.ui.geometry.Offset, ballSize: Dp, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .offset { IntOffset(ballOffset.x.roundToInt(), ballOffset.y.roundToInt()) }
            .size(ballSize)
            .background(Color.Red, shape = CircleShape)
            .clickable { onClick() }
    )
}

