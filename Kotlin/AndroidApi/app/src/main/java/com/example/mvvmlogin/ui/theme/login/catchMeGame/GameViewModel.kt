package com.example.mvvmlogin.ui.theme.login.catchMeGame

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.unit.IntSize
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

class GameViewModel(private val context: Context) : ViewModel() {

    var timeLeft by mutableStateOf(30)
        private set
    var score by mutableStateOf(0)
        private set
    var gameRunning by mutableStateOf(false)
        private set
    var ballOffset by mutableStateOf(Offset.Zero)
        private set
    var gameAreaSize by mutableStateOf(IntSize.Zero)
        private set
    val ballSize: Int = 50

    var showGameOverDialog by mutableStateOf(false)
        private set
    var topScores: List<Int> by mutableStateOf(emptyList())
        private set

    private val prefs: SharedPreferences =
        context.getSharedPreferences("GameScores", Context.MODE_PRIVATE)

    fun startGame() {
        timeLeft = 30
        score = 0
        gameRunning = true

        viewModelScope.launch {
            while (timeLeft > 0 && gameRunning) {
                delay(1000L)
                timeLeft--
            }
            gameRunning = false
            saveScore()
            showGameOverDialog = true
        }

        viewModelScope.launch {
            while (gameRunning) {
                delay(1000L)
                updateBallPosition()
            }
        }
    }

    private fun updateBallPosition() {
        if (gameAreaSize.width > 0 && gameAreaSize.height > 0) {
            val maxX = (gameAreaSize.width - ballSize).coerceAtLeast(0)
            val maxY = (gameAreaSize.height - ballSize).coerceAtLeast(0)
            val randomX = Random.nextInt(0, maxX).toFloat()
            val randomY = Random.nextInt(0, maxY).toFloat()
            ballOffset = Offset(randomX, randomY)
        }
    }

    fun onBallClicked() {
        if (gameRunning && timeLeft > 0) {
            score++
        }
    }

    fun updateGameAreaSize(size: IntSize) {
        gameAreaSize = size
    }

    private fun saveScore() {
        val scores =
            prefs.getStringSet("topScores", mutableSetOf())?.toMutableList() ?: mutableListOf()
        scores.add(score.toString())
        val topScoresInt = scores.map { it.toInt() }.sortedDescending().take(5)
        topScores = topScoresInt
        val updatedScores = topScoresInt.map { it.toString() }.toSet()
        prefs.edit().putStringSet("topScores", updatedScores).apply()
    }

    fun dismissGameOverDialog() {
        showGameOverDialog = false
    }
}
