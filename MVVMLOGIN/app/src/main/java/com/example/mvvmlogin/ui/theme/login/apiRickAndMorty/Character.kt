package com.example.mvvmlogin.ui.theme.login.apiRickAndMorty

data class Character (
    val id: Int,
    val name: String,
    val image: String
)

data class CharacterResponse(
    val results: List<Character>
)