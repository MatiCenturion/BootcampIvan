//package com.example.mvvmlogin
//
//import android.os.Bundle
//import androidx.activity.ComponentActivity
//import androidx.activity.compose.setContent
//import androidx.compose.material3.MaterialTheme
//import androidx.compose.material3.Surface
//import androidx.compose.ui.platform.LocalContext
//import androidx.navigation.compose.NavHost
//import androidx.navigation.compose.composable
//import androidx.navigation.compose.rememberNavController
//import com.example.mvvmlogin.ui.theme.MVVMLOGINTheme
//import com.example.mvvmlogin.ui.theme.login.menu.MenuScreen
//import com.example.mvvmlogin.ui.theme.login.ui.LoginScreen
//import com.example.mvvmlogin.ui.theme.login.ui.LoginViewModel
//import com.example.mvvmlogin.ui.theme.login.catchMeGame.GameScreen
//import com.example.mvvmlogin.ui.theme.login.catchMeGame.GameViewModel
//import com.example.mvvmlogin.ui.theme.login.rickAndMorty.RickAndMortyViewModel
//
//
//
//class MainActivity : ComponentActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContent {
//            MVVMLOGINTheme {
//                Surface(color = MaterialTheme.colorScheme.background) {
//                    val navController = rememberNavController()
//                    NavHost(navController = navController, startDestination = "login") {
//                        composable("login") {
//                            // Instancia del LoginViewModel
//                            val loginViewModel = LoginViewModel()
//                            LoginScreen(
//                                viewModel = loginViewModel,
//                                onLoginSuccess = {
//                                    // Navegar al menú una vez completado el login
//                                    navController.navigate("menu")
//                                }
//                            )
//                        }
//                        composable("menu") {
//                            MenuScreen(
//                                onGameSelected = {
//                                    navController.navigate("game")
//                                }
//                            )
//                        }
//                        composable("game") {
//                            val context = LocalContext.current
//                            val gameViewModel = GameViewModel(context)
//                            GameScreen(viewModel = gameViewModel)
//                            GameScreen(viewModel = gameViewModel)
//                        }
//
//                    }
//                }
//            }
//        }
//    }
//}

package com.example.mvvmlogin

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.mvvmlogin.ui.theme.MVVMLOGINTheme
import com.example.mvvmlogin.ui.theme.login.menu.MenuScreen
import com.example.mvvmlogin.ui.theme.login.ui.LoginScreen
import com.example.mvvmlogin.ui.theme.login.ui.LoginViewModel
import com.example.mvvmlogin.ui.theme.login.catchMeGame.GameScreen
import com.example.mvvmlogin.ui.theme.login.catchMeGame.GameViewModel
//import com.example.mvvmlogin.ui.theme.login.apiRickAndMorty.RickAndMortyViewModel
import com.example.mvvmlogin.ui.theme.login.apiRickAndMorty.RickAndMortyScreen
import com.example.mvvmlogin.ui.theme.login.apiRickAndMorty.RickAndMortyViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MVVMLOGINTheme {
                Surface(color = MaterialTheme.colorScheme.background) {
                    val navController = rememberNavController()
                    NavHost(navController = navController, startDestination = "login") {
                        composable("login") {
                            val loginViewModel = LoginViewModel()
                            LoginScreen(
                                viewModel = loginViewModel,
                                onLoginSuccess = { navController.navigate("menu") }
                            )
                        }
                        composable("menu") {
                            MenuScreen(
                                onGameSelected = { navController.navigate("game") },
                                onRickAndMortySelected = { navController.navigate("apiSolicitud") }
                            )
                        }
                        composable("game") {
                            val context = LocalContext.current
                            val gameViewModel = GameViewModel(context)
                            GameScreen(viewModel = gameViewModel)
                        }
                        composable("apiSolicitud") {
                            val rickAndMortyViewModel:
                                    RickAndMortyViewModel = viewModel()
                            RickAndMortyScreen(viewModel = rickAndMortyViewModel)
                        }

                    }
                }
            }
        }
    }
}
