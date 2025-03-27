package com.example.mvvmlogin.ui.theme.login.apiRickAndMorty

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET

interface RickAndMortyApi {
    @GET("character")
    suspend fun getCharacters(): CharacterResponse

    companion object {
        private const val BASE_URL = "https://rickandmortyapi.com/api/"

        fun create(): RickAndMortyApi {
            return Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
                .create(RickAndMortyApi::class.java)
        }
    }
}


