package com.example.mvvmlogin.ui.theme.login.apiRickAndMorty

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class RickAndMortyViewModel : ViewModel() {

    private val api = RickAndMortyApi.create()

    private val _characters = MutableStateFlow<List<Character>>(emptyList())
    val characters: StateFlow<List<Character>> = _characters

    init {
        fetchCharacters()
    }

    private fun fetchCharacters() {
        viewModelScope.launch {
            try {
                val response = api.getCharacters()
                _characters.value = response.results
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
