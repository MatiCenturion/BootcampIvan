package com.example.primerapp

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.primerapp.firsApp.firstAppActivity
import com.example.primerapp.imcCalculator.ImcCalculatorActivity
import com.example.primerapp.superheroapp.SuperHeroListActivity


class MenuActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_menu)

        val btnSaludApp = findViewById<Button>(R.id.btnSaludApp)
        val btnIMCApp = findViewById<Button>(R.id.btnIMCApp)
        val  btnSuperHero = findViewById<Button>(R.id.btnSuperHero)

        btnSuperHero.setOnClickListener{navigateToSuperHeroApp()}
        btnSaludApp.setOnClickListener{ navigateToSaludApp() }
        btnIMCApp.setOnClickListener{navigateToImcApp()}


        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun navigateToSuperHeroApp() {
        val intent = Intent(this, SuperHeroListActivity::class.java )
        startActivity(intent)
    }

    private fun navigateToSaludApp() {
        val intent = Intent(this, firstAppActivity::class.java)
        startActivity(intent)
    }

    private fun navigateToImcApp() {
        val intent = Intent(this, ImcCalculatorActivity::class.java )
        startActivity(intent)
    }
}