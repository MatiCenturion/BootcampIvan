package com.example.mvvmlogin.ui.theme.login.catchMeGame


import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.Alignment
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.onSizeChanged
import com.example.mvvmlogin.ui.theme.login.catchMeGame.GameViewModel

@Composable
fun GameScreen(viewModel: GameViewModel) {
    // Observa los estados desde el ViewModel
    val timeLeft = viewModel.timeLeft
    val score = viewModel.score
    val ballOffset = viewModel.ballOffset
    val gameRunning = viewModel.gameRunning

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(16.dp))
        Text(text = "Tiempo: $timeLeft")
        Text(text = "Puntos: $score")
        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = { viewModel.startGame() },
            enabled = !gameRunning,
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp)
        ) {
            Text(text = "Iniciar Juego")
        }
        Spacer(modifier = Modifier.height(16.dp))
        // Área de juego: se mide su tamaño para limitar el movimiento de la bola
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
                .onSizeChanged { size: IntSize -> viewModel.updateGameAreaSize(size) }
        ) {
            Ball(
                ballOffset = ballOffset,
                ballSize = viewModel.ballSize.dp,  // convierte el Int a Dp
                onClick = { viewModel.onBallClicked() }
            )

        }
    }

    // Diálogo que muestra los top puntajes al finalizar el juego
    if (viewModel.showGameOverDialog) {
        AlertDialog(
            onDismissRequest = { viewModel.dismissGameOverDialog() },
            title = { Text("¡Juego terminado!") },
            text = {
                Column {
                    Text(text = "Top 5 Puntajes:")
                    viewModel.topScores.forEachIndexed { index, puntaje ->
                        Text(text = "${index + 1}. $puntaje puntos")
                    }
                }
            },
            confirmButton = {
                Button(onClick = { viewModel.dismissGameOverDialog() }) {
                    Text("OK")
                }
            }
        )
    }
}

@Composable
fun Ball(ballOffset: Offset, ballSize: Int, onClick: () -> Unit) {
    // Convertir el tamaño en dp
    val ballSizeDp = with(LocalDensity.current) { ballSize.dp }
    Box(
        modifier = Modifier
            .offset(x = ballOffset.x.dp, y = ballOffset.y.dp)
            .size(ballSizeDp)
            .clickable(onClick = onClick),
        contentAlignment = Alignment.Center
    ) {
        // Representación simple de la bola
        Surface(
            shape = MaterialTheme.shapes.small,
            color = Color.Red
        ) {}
    }
}

